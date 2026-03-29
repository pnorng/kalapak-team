<?php

namespace App\Http\Controllers;

use App\Models\Project;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProjectController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Project::query();

        if ($request->filled('search')) {
            $query->where('title', 'ilike', '%' . $request->search . '%');
        }

        if ($request->filled('featured')) {
            $query->where('is_featured', true);
        }

        $projects = $query->orderByDesc('created_at')->get();

        return response()->json(['data' => $projects]);
    }

    public function show(Project $project): JsonResponse
    {
        return response()->json(['data' => $project]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'cover_image' => ['nullable', 'url', 'max:500'],
            'tech_stack' => ['nullable', 'array'],
            'github_url' => ['nullable', 'url', 'max:500'],
            'live_url' => ['nullable', 'url', 'max:500'],
            'is_featured' => ['boolean'],
        ]);

        $project = Project::create($validated);

        return response()->json(['message' => 'Project created.', 'data' => $project], 201);
    }

    public function update(Request $request, Project $project): JsonResponse
    {
        $validated = $request->validate([
            'title' => ['sometimes', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'cover_image' => ['nullable', 'url', 'max:500'],
            'tech_stack' => ['nullable', 'array'],
            'github_url' => ['nullable', 'url', 'max:500'],
            'live_url' => ['nullable', 'url', 'max:500'],
            'is_featured' => ['boolean'],
        ]);

        $project->update($validated);

        return response()->json(['message' => 'Project updated.', 'data' => $project]);
    }

    public function destroy(Project $project): JsonResponse
    {
        $project->delete();

        return response()->json(['message' => 'Project deleted.']);
    }
}
