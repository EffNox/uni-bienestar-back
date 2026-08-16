package io.owl.bienestar.user;

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
public class User {

  @Id 
  @GeneratedValue
  private UUID id;

  private String email;
  private String password_hash;
  private String role; // PACIENTE, DOCTOR, ENTIDAD
  private boolean verified;
  private boolean active;
  private String totpSecret;
}
