package io.owl.bienestar.medication_log;

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
public class MedicationLog {

    @Id
    @GeneratedValue
    private UUID id;

    private UUID medicacionId;
    private LocalDateTime fechaHoraProgramada;
    private boolean cumplida;
    private LocalDateTime fechaHoraRealizacion;
}
