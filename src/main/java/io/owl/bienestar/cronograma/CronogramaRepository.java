package io.owl.bienestar.cronograma;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CronogramaRepository extends JpaRepository<Cronograma, UUID> { }
