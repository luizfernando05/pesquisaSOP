import axios from 'axios';
import { AdviceRequestDTO, AdviceResponseDTO } from '../dtos/AdviceRequestDTO';
import { AppError } from '../../shared/errors/AppError';

export class AdviceService {
  private apiUrl: string;

  constructor() {
    this.apiUrl = 'https://api.cohere.ai/v1/generate';
  }

  async generateAdvice(data: AdviceRequestDTO): Promise<AdviceResponseDTO> {
    try {
      const response = await axios.post(
        this.apiUrl,
        {
          model: 'command-r-plus-08-2024',
          prompt: `
      You are a women's health specialist. Your task is to provide a clear, non-technical explanation of the patient's diagnosis related to Polycystic Ovary Syndrome (PCOS), based on the provided clinical data. Then, offer **one simple, actionable lifestyle tip** to help manage symptoms of PCOS.

      **Important Guidelines:**
      - Do NOT reinterpret the diagnosis. Treat the prediction as final.
      - Focus your explanation on:
        1. How the reported symptoms and lab values are commonly associated with PCOS.
        2. Which features in the patient's data support the diagnosis.
        3. End with one short, realistic lifestyle tip (1–2 sentences max).

      **Output Format:**
      - First: brief explanation of the diagnosis based on the patient's data.
      - Then: one practical tip.

      **Example:**
      Diagnosis: PCOS  
      Confidence: 94.7%  
      Weight: 85kg | Cycle Irregularity: Yes | AMH: 6.5 | Acne: Yes | Fast Food: Frequent  
      Explanation: The high AMH level, irregular cycles, and signs like acne and frequent fast food consumption align with common PCOS symptoms. The elevated weight also increases risk.  
      Tip: Start with small dietary changes, like reducing sugary drinks and adding more vegetables.

      ---

      **Patient Information:**  
      - Name: ${data.patientName}  

      **Clinical Data:**  
      - Weight: ${data.medicalData.weight} kg  
      - Menstrual Cycle Length: ${data.medicalData.cycle} weeks  
      - Anti-Müllerian Hormone (AMH): ${data.medicalData.amg}  
      - Excessive Weight Gain: ${data.medicalData.weightGain ? 'Yes' : 'No'}  
      - Hair Loss: ${data.medicalData.hairLoss ? 'Yes' : 'No'}  
      - Skin Darkening: ${data.medicalData.darkeningSkin ? 'Yes' : 'No'}  
      - Pimples/Acne: ${data.medicalData.pimple ? 'Yes' : 'No'}  
      - Frequent Fast Food Intake: ${data.medicalData.fastFood ? 'Yes' : 'No'}  
      - Left Ovary Follicle Count: ${data.medicalData.leftFollicles}  
      - Right Ovary Follicle Count: ${data.medicalData.rightFollicles}  

      **Confirmed Diagnosis:** ${data.prediction.result} (Confidence: ${(data.prediction.confidenceScore * 100).toFixed(1)}%).

      Now explain the diagnosis and end with one brief tip.
      `,
          max_tokens: 500,
          temperature: 0.7,
        },
        {
          headers: {
            Authorization: `Bearer ${process.env.COHERE_API_KEY}`,
            'Content-Type': 'application/json',
          },
        }
      );

      const advice = response.data.generations[0].text.trim();

      return { tips: advice };
    } catch (err) {
      console.error('Error communicating with Cohere API:', err);
      throw new AppError('Error generating advice using Cohere model', 500);
    }
  }
}

export default AdviceService;
