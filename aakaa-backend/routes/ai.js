import express from 'express';
import { GoogleGenerativeAI } from '@google/generative-ai';
import auth from '../middleware/auth.js';

const router = express.Router();

// Initialize Gemini Client safely
const initializeGemini = () => {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey || apiKey === 'your_gemini_api_key_here') {
    console.warn('⚠️ GEMINI_API_KEY is not configured in .env. Falling back to structured clinical mock responses.');
    return null;
  }
  return new GoogleGenerativeAI(apiKey);
};

// Helper to provide a highly realistic mock response if the API key is not configured
const generateMockCbtAnalysis = (text) => {
  const t = text.toLowerCase();
  if (t.includes('sad') || t.includes('depressed') || t.includes('cry') || t.includes('alone')) {
    return {
      sentiment: "Melancholic Waves",
      sentimentColor: "#FF8A00",
      distortion: "Emotional Reasoning",
      advice: "You are feeling intense sorrow, which makes things seem hopeless right now. Remember: feelings are waves, not facts. Let them wash over you without defining your future. (Mock Fallback)"
    };
  } else if (t.includes('anxious') || t.includes('stressed') || t.includes('worry') || t.includes('scared') || t.includes('panic')) {
    return {
      sentiment: "Anxious Energy",
      sentimentColor: "#FF5252",
      distortion: "Catastrophizing (Assuming the worst)",
      advice: "Your brain is attempting to forecast danger. Gently remind your nervous system that you are in the safe, quiet space of the present moment. Focus on 3 things you can see. (Mock Fallback)"
    };
  } else if (t.includes('hate') || t.includes('angry') || t.includes('annoyed') || t.includes('mad') || t.includes('worst')) {
    return {
      sentiment: "Frustrated / Irritated",
      sentimentColor: "#E040FB",
      distortion: "All-or-Nothing Thinking",
      advice: "When angry, it's easy to view everything through an extreme lens. Try to look for the grey areas—every challenging event contains parts that are neutral or workable. (Mock Fallback)"
    };
  } else {
    return {
      sentiment: "Calm & Centered",
      sentimentColor: "#0A7D62",
      distortion: "Healthy Core Intention",
      advice: "Your thoughts show beautiful self-awareness and balance. Continuing this journaling discipline will strengthen your emotional resilience dramatically. (Mock Fallback)"
    };
  }
};

// @route   POST /api/ai/analyze-journal
// @desc    Analyze user's journal reflection under the CBT framework (detecting sentiment, cognitive distortions, and reframing advice)
// @access  Private
router.post('/analyze-journal', auth, async (req, res) => {
  try {
    const { content } = req.body;

    if (!content || content.trim().isEmpty) {
      return res.status(400).json({
        status: 'error',
        message: 'Journal content cannot be empty.'
      });
    }

    const genAI = initializeGemini();

    // Fallback if no API key is specified
    if (!genAI) {
      const mockResult = generateMockCbtAnalysis(content);
      return res.json({
        status: 'success',
        ...mockResult
      });
    }

    // Call Gemini 1.5 Flash with structured JSON constraint
    const model = genAI.getGenerativeModel({ 
      model: 'gemini-1.5-flash',
      generationConfig: { responseMimeType: 'application/json' }
    });

    const prompt = `
You are a brilliant, world-class empathetic AI Clinical Coach specializing in Cognitive Behavioral Therapy (CBT).
You are analyzing a client's highly personal journal entry. 

Your task is to analyze the text and output a JSON object containing:
1. "sentiment": A string describing the core emotional spectrum (e.g. "Anxious Energy", "Melancholic Waves", "Frustrated / Irritated", "Calm & Centered", "Guilt & Shame", etc.)
2. "sentimentColor": A single hexadecimal string starting with "#" corresponding to a nice pastel/harmonic accent color that suits the sentiment (e.g. Anxious/Stressed = "#FF5252", Sad/Melancholy = "#FF8A00", Angry/Frustrated = "#E040FB", Peaceful/Happy = "#0A7D62").
3. "distortion": Identify any cognitive distortion present (e.g., Catastrophizing, All-or-Nothing Thinking, Emotional Reasoning, Overgeneralization, Personalization, Mind Reading, or "None detected (Healthy emotional waves)").
4. "advice": Empowering, clinical, yet highly compassionate CBT reframe or breakthrough advice. Limit to 3 empathetic, highly focused sentences. Avoid clinical jargon; speak to their heart and encourage self-compassion.

Client Journal Entry:
"${content.replace(/"/g, '\\"')}"

Output JSON format strictly conforming to this exact structure:
{
  "sentiment": "...",
  "sentimentColor": "...",
  "distortion": "...",
  "advice": "..."
}
    `;

    const result = await model.generateContent(prompt);
    const responseText = result.response.text();
    
    let parsedData;
    try {
      parsedData = JSON.parse(responseText.trim());
    } catch (parseErr) {
      console.error('Failed to parse Gemini JSON response:', responseText);
      // Fallback in case response is invalid JSON
      parsedData = generateMockCbtAnalysis(content);
    }

    res.json({
      status: 'success',
      ...parsedData
    });

  } catch (err) {
    console.error('AI Journal Analysis Error:', err);
    res.status(500).json({
      status: 'error',
      message: 'An error occurred during AI analysis.',
      error: err.message
    });
  }
});

export default router;
