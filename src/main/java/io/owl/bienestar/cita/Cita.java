package io.owl.bienestar.cita;

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
public class Cita {

    @Id
    @GeneratedValue
    private UUID id;

    private UUID cronogramaId;
    private LocalDateTime fechaHora;
    private String lugar;
    private String notas;
}
