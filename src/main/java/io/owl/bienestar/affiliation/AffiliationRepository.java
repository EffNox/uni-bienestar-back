package io.owl.bienestar.affiliation;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AffiliationRepository extends JpaRepository<Affiliation, UUID> { }
