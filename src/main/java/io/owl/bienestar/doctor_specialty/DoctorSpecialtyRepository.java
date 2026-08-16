package io.owl.bienestar.doctor_specialty;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DoctorSpecialtyRepository extends JpaRepository<DoctorSpecialty, UUID> { }
