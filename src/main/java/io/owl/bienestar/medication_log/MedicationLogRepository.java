package io.owl.bienestar.medication_log;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MedicationLogRepository extends JpaRepository<MedicationLog, UUID> { }
