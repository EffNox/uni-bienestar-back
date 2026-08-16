package io.owl.bienestar.doctor_symptom;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DoctorSymptomRepository extends JpaRepository<DoctorSymptom, UUID> { }
