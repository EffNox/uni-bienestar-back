package io.owl.bienestar.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.UUID;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Data
@Builder
@jakarta.persistence.Entity
@NoArgsConstructor
@AllArgsConstructor
public class Entity {

    @Id
    @GeneratedValue
    private UUID id;

    private UUID userId;
    private String ruc;
    private String razonSocial;
    private String tipoEntidad;
    private String direccion;
    private boolean verificado;
    private boolean activo;
}
