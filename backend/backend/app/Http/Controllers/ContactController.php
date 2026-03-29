<?php

namespace App\Http\Controllers;

use App\Models\ContactMessage;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ContactController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255'],
            'subject' => ['nullable', 'string', 'max:500'],
            'message' => ['required', 'string', 'max:5000'],
        ]);

        ContactMessage::create([
            ...$validated,
            'created_at' => now(),
        ]);

        return response()->json(['message' => 'Your message has been sent. Thank you!'], 201);
    }

    public function index(Request $request): JsonResponse
    {
        $messages = ContactMessage::orderByDesc('created_at')->paginate(20);

        return response()->json($messages);
    }

    public function markRead(ContactMessage $contactMessage): JsonResponse
    {
        $contactMessage->update(['is_read' => true]);

        return response()->json(['message' => 'Marked as read.']);
    }
}
