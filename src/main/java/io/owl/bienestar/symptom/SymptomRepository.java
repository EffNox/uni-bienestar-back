package io.owl.bienestar.symptom;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SymptomRepository extends JpaRepository<Symptom, UUID> { }
