package io.owl.bienestar.user;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;


// @PreAuthorize("hasAnyRole('DOCTOR', 'ADMIN')")
// @PreAuthorize("hasRole('DOCTOR')")
public interface UserRepository extends JpaRepository<User, UUID> { 
    Optional<User> findByEmail(String email);
}
