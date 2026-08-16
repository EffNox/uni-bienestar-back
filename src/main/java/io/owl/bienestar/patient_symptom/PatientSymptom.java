package io.owl.bienestar.patient_symptom;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.UUID;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Data
@Builder
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class PatientSymptom {

    @Id
    @GeneratedValue
    private UUID id;

    private UUID patientId;
    private UUID symptomId;
    private LocalDateTime fechaRegistro;
}
