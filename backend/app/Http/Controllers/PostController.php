<?php

namespace App\Http\Controllers;

use App\Models\Post;
use App\Models\Comment;
use App\Models\Like;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class PostController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Post::with('author:id,name,avatar')
            ->withCount('likes', 'comments')
            ->where('is_published', true);

        if ($request->filled('category')) {
            $query->where('category', $request->category);
        }

        if ($request->filled('search')) {
            $query->where('title', 'ilike', '%' . $request->search . '%');
        }

        $posts = $query->orderByDesc('created_at')->paginate(10);

        return response()->json($posts);
    }

    public function show(string $slug): JsonResponse
    {
        $post = Post::with('author:id,name,avatar')
            ->withCount('likes', 'comments')
            ->where('slug', $slug)
            ->where('is_published', true)
            ->firstOrFail();

        return response()->json(['data' => $post]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:500'],
            'content' => ['required', 'string'],
            'thumbnail' => ['nullable', 'url', 'max:500'],
            'images' => ['nullable', 'array'],
            'images.*' => ['url', 'max:500'],
            'category' => ['nullable', 'string', 'max:100'],
            'is_published' => ['boolean'],
        ]);

        $post = Post::create([
            ...$validated,
            'author_id' => $request->user()->id,
            'slug' => Str::slug($validated['title']) . '-' . Str::random(6),
        ]);

        return response()->json(['message' => 'Post created.', 'data' => $post], 201);
    }

    public function update(Request $request, Post $post): JsonResponse
    {
        $validated = $request->validate([
            'title' => ['sometimes', 'string', 'max:500'],
            'content' => ['sometimes', 'string'],
            'thumbnail' => ['nullable', 'url', 'max:500'],
            'images' => ['nullable', 'array'],
            'images.*' => ['url', 'max:500'],
            'category' => ['nullable', 'string', 'max:100'],
            'is_published' => ['boolean'],
        ]);

        $post->update($validated);

        return response()->json(['message' => 'Post updated.', 'data' => $post]);
    }

    public function destroy(Post $post): JsonResponse
    {
        $post->delete();

        return response()->json(['message' => 'Post deleted.']);
    }

    public function like(Request $request, Post $post): JsonResponse
    {
        $userId = $request->user()->id;
        $existing = Like::where('post_id', $post->id)->where('user_id', $userId)->first();

        if ($existing) {
            $existing->delete();
            $liked = false;
        } else {
            Like::create(['post_id' => $post->id, 'user_id' => $userId]);
            $liked = true;
        }

        return response()->json([
            'liked' => $liked,
            'likes_count' => Like::where('post_id', $post->id)->count(),
        ]);
    }

    public function comment(Request $request, Post $post): JsonResponse
    {
        $validated = $request->validate([
            'content' => ['required', 'string', 'max:2000'],
        ]);

        $comment = Comment::create([
            'post_id' => $post->id,
            'user_id' => $request->user()->id,
            'content' => $validated['content'],
            'created_at' => now(),
        ]);

        $comment->load('user:id,name,avatar');

        return response()->json(['message' => 'Comment added.', 'data' => $comment], 201);
    }

    public function comments(Post $post): JsonResponse
    {
        $comments = $post->comments()
            ->with('user:id,name,avatar')
            ->orderByDesc('created_at')
            ->get();

        return response()->json(['data' => $comments]);
    }
}
