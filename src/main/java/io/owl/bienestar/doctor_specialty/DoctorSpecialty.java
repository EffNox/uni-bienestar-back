package io.owl.bienestar.doctor_specialty;

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
public class DoctorSpecialty {

    @Id
    @GeneratedValue
    private UUID id;

    private UUID doctorId;
    private UUID specialtyId;
}
