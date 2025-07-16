export interface AdviceRequestDTO {
  patientName: string;
  medicalData: {
    weight: number;
    cycle: number;
    amg: number;
    weightGain: boolean;
    hairLoss: boolean;
    darkeningSkin: boolean;
    pimple: boolean;
    fastFood: boolean;
    leftFollicles: number;
    rightFollicles: number;
  };
  prediction: {
    result: string;
    confidenceScore: number;
  };
}

export interface AdviceResponseDTO {
  tips: string;
}
