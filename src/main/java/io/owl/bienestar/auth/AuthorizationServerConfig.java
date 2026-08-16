package io.owl.bienestar.auth;

import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.util.UUID;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.OAuth2AuthorizationServerConfiguration;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.core.oidc.OidcScopes;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.NimbusJwtEncoder;
import org.springframework.security.oauth2.server.authorization.client.InMemoryRegisteredClientRepository;
import org.springframework.security.oauth2.server.authorization.client.RegisteredClient;
import org.springframework.security.oauth2.server.authorization.client.RegisteredClientRepository;
import org.springframework.security.oauth2.server.authorization.settings.AuthorizationServerSettings;
import com.nimbusds.jose.jwk.JWKSet;
import com.nimbusds.jose.jwk.RSAKey;
import com.nimbusds.jose.jwk.source.ImmutableJWKSet;
import com.nimbusds.jose.jwk.source.JWKSource;
import com.nimbusds.jose.proc.SecurityContext;

@Configuration(proxyBeanMethods = false)
public class AuthorizationServerConfig {

    @Bean
    RegisteredClientRepository registeredClientRepository() {

        RegisteredClient client =
            RegisteredClient.withId(UUID.randomUUID().toString())
                .clientId("bienestar-app")
                .clientSecret("{noop}secret")

                .authorizationGrantType( AuthorizationGrantType.JWT_BEARER)

                .redirectUri( "http://127.0.0.1:8080/login/oauth2/code/bienestar")

                .scope(OidcScopes.OPENID)
                .scope(OidcScopes.PROFILE)

                .build();

        return new InMemoryRegisteredClientRepository(client);
    }

    @Bean
    JWKSource<SecurityContext> jwkSource() {
      KeyPair keyPair = generateRsaKeyPair();
      RSAPublicKey publicKey = (RSAPublicKey) keyPair.getPublic();
      RSAPrivateKey privateKey = (RSAPrivateKey) keyPair.getPrivate();
      RSAKey rsaKey =
        new RSAKey.Builder(publicKey)
        .privateKey(privateKey)
        .keyID(UUID.randomUUID().toString())
        .build();
      return new ImmutableJWKSet<>( new JWKSet(rsaKey));
    }

    @Bean
    JwtEncoder jwtEncoder( JWKSource<SecurityContext> jwkSource) {
      return new NimbusJwtEncoder(jwkSource);
    }

    @Bean
    JwtDecoder jwtDecoder( JWKSource<SecurityContext> jwkSource) {
      return OAuth2AuthorizationServerConfiguration .jwtDecoder(jwkSource);
    }

    @Bean
    AuthorizationServerSettings authorizationServerSettings() {
      return AuthorizationServerSettings.builder()
        .issuer("http://localhost:8080")
        .build();
    }

    private static KeyPair generateRsaKeyPair() {
      try {
        KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
        generator.initialize(2048);
        return generator.generateKeyPair();
      } catch (Exception exception) {
        throw new IllegalStateException( "No se pudo generar la clave RSA", exception);
      }
    }

}
