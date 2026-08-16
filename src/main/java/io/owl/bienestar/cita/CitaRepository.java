package io.owl.bienestar.cita;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CitaRepository extends JpaRepository<Cita, UUID> { }
