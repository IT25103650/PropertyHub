package com.realestate.repositories;

import com.realestate.models.BuyerEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository
public interface BuyerRepository extends JpaRepository<BuyerEntity, Integer> {

    // Basic Query Methods
    Optional<BuyerEntity> findByEmail(String email);


    List<BuyerEntity> findByIsActiveTrue();


    boolean existsByEmail(String email);


    // Custom Query Method

    @Query("SELECT b FROM BuyerEntity b WHERE b.role IN ('buyer', 'both') ORDER BY b.createdAt DESC")
    List<BuyerEntity> findAllBuyers();


    @Query("SELECT b FROM BuyerEntity b WHERE " +
            "LOWER(b.firstName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(b.lastName)  LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(b.email)     LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<BuyerEntity> searchBuyers(@Param("keyword") String keyword);

}