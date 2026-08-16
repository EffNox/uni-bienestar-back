package io.owl.bienestar.medicacion;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MedicacionRepository extends JpaRepository<Medicacion, UUID> { }
