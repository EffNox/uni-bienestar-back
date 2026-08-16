package io.owl.bienestar.doctor_symptom;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.UUID;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Data
@Builder
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class DoctorSymptom {

    @Id
    @GeneratedValue
    private UUID id;

    private UUID doctorId;
    private UUID symptomId;
}
