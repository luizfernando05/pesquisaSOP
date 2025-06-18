export interface PredictionRequestDTO {
  weight: number;
  cycle: boolean;
  amg: number;
  weightGain: boolean;
  hairLoss: boolean;
  darkeningSkin: boolean;
  pimple: boolean;
  fastFood: boolean;
  leftFollicles: number;
  rightFollicles: number;
}

export interface PredictionResponseDTO {
  predictionResult: string;
  confidenceScore: number;
}
