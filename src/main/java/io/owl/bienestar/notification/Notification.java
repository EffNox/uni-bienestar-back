package io.owl.bienestar.notification;

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
public class Notification {

    @Id
    @GeneratedValue
    private UUID id;

    private UUID userId;
    private String tipo;
    private String titulo;
    private String contenido;
    private boolean leida;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaLectura;
}
