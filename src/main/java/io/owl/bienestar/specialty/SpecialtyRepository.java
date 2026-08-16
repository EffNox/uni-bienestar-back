package io.owl.bienestar.specialty;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SpecialtyRepository extends JpaRepository<Specialty, UUID> { }
