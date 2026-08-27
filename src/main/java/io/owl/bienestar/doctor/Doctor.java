package io.owl.bienestar.doctor;

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
public class Doctor {
    @Id
    @GeneratedValue
    private UUID id;
    
    private UUID userId;            // referencia a UserModel

    private String firstname;
    private String lastname;
    private String dni;
    private String cmp;
    private String biografia;
    private boolean esIndependiente;
    private boolean esDependiente;
}
