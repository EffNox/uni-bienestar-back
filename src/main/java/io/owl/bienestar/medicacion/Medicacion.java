package io.owl.bienestar.medicacion;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.util.UUID;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Data
@Builder
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class Medicacion {

    @Id
    @GeneratedValue
    private UUID id;

    private UUID cronogramaId;
    private String nombreMedicamento;
    private String presentacion;
    private String dosis;
    private String frecuencia;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
}
