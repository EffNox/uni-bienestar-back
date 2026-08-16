package io.owl.bienestar.patient;

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
public class Patient {

    @Id
    @GeneratedValue
    private UUID id;
    
    private UUID userId;                // referencia a UserModel
    private String dni;
    private String nombres;
    private String apellidos;
    private LocalDate fechaNacimiento;
    private String estadoActual;        // BUSCANDO_DOCTOR, EN_REVISION, EN_MEDICACION

}
