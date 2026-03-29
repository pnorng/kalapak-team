<?php

namespace App\Http\Controllers;

use App\Models\Skill;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SkillController extends Controller
{
    public function index(): JsonResponse
    {
        $skills = Skill::orderBy('category')->orderBy('sort_order')->get();
        $grouped = $skills->groupBy('category');

        return response()->json(['data' => $grouped]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:100'],
            'icon_url' => ['nullable', 'url', 'max:500'],
            'category' => ['nullable', 'string', 'max:100'],
            'sort_order' => ['integer', 'min:0'],
        ]);

        $skill = Skill::create($validated);

        return response()->json(['message' => 'Skill created.', 'data' => $skill], 201);
    }

    public function update(Request $request, Skill $skill): JsonResponse
    {
        $validated = $request->validate([
            'name' => ['sometimes', 'string', 'max:100'],
            'icon_url' => ['nullable', 'url', 'max:500'],
            'category' => ['nullable', 'string', 'max:100'],
            'sort_order' => ['integer', 'min:0'],
        ]);

        $skill->update($validated);

        return response()->json(['message' => 'Skill updated.', 'data' => $skill]);
    }

    public function destroy(Skill $skill): JsonResponse
    {
        $skill->delete();

        return response()->json(['message' => 'Skill deleted.']);
    }
}
