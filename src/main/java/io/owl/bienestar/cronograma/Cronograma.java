package io.owl.bienestar.cronograma;

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
public class Cronograma {

    @Id
    @GeneratedValue
    private UUID id;

    private UUID doctorId;
    private UUID patientId;
    private String tipoCronograma;
    private LocalDateTime fechaCreacion;
    private String estado;
}
