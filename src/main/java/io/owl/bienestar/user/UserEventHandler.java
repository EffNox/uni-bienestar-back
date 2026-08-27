package io.owl.bienestar.user;

import org.springframework.data.rest.core.annotation.HandleBeforeCreate;
import org.springframework.data.rest.core.annotation.RepositoryEventHandler;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import lombok.RequiredArgsConstructor;

@Component
@RepositoryEventHandler
@RequiredArgsConstructor
public class UserEventHandler {

    private final PasswordEncoder passwordEncoder;

    @HandleBeforeCreate
    public void handleBeforeCreate(User user) {
        user.setPassword_hash(passwordEncoder.encode(user.getPassword()));
    }
}
