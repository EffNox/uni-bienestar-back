package io.owl.bienestar.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.UUID;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Transient;

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

  @Transient
  private String password;

  @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
  private String password_hash;
  private String role; // PACIENTE, DOCTOR, ENTIDAD
  private boolean verified;
  private boolean active;
  private String totpSecret;
}
