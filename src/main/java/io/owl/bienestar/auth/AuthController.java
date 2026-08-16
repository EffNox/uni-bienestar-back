package io.owl.bienestar.auth;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import io.swagger.v3.oas.annotations.security.SecurityRequirements;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

  private final AuthenticationManager authenticationManager;
  private final JwtEncoder jwtEncoder;

  public record LoginRequest( String email, String password) {}
  public record LoginResponse( String accessToken, String tokenType, long expiresIn) {}

  @PostMapping("/login")
  @SecurityRequirements()
  public LoginResponse login( @RequestBody LoginRequest request) {

    Authentication authentication = authenticationManager.authenticate( new UsernamePasswordAuthenticationToken( request.email(), request.password()));

    Instant now = Instant.now();

    List<String> authorities =
      authentication.getAuthorities()
      .stream()
      .map(authority -> authority.getAuthority())
      .toList();

    JwtClaimsSet claims = JwtClaimsSet.builder()
      .issuer("http://localhost:8080")
      .subject(authentication.getName())
      .issuedAt(now)
      .expiresAt(now.plus(1, ChronoUnit.HOURS))
      .claim("roles", authorities)
      .build();

    String token = jwtEncoder.encode(JwtEncoderParameters.from(claims)).getTokenValue();

    return new LoginResponse( token, "Bearer", 3600);
  }
}
