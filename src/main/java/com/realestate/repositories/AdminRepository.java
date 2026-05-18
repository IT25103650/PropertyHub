package com.realestate.repositories;
import com.realestate.models.*;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface for Admin entity data access.
 *
 * Component 05 - Admin Management
 * Developer: [Student 5]
 */
@Repository
public interface AdminRepository extends JpaRepository<AdminEntity, Integer> {

    /** Find an admin by email address. */
    Optional<AdminEntity> findByEmail(String email);

    /** Find all admins (role = 'admin'). */
    @Query("SELECT a FROM AdminEntity a WHERE a.role = 'admin' ORDER BY a.createdAt DESC")
    List<AdminEntity> findAllAdmins();

    /** Search admins by name or email. */
    @Query("SELECT a FROM AdminEntity a WHERE a.role = 'admin' AND (" +
            "LOWER(a.firstName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(a.lastName)  LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(a.email)     LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<AdminEntity> searchAdmins(@Param("keyword") String keyword);

    /** Check if email is already registered. */
    boolean existsByEmail(String email);
}
