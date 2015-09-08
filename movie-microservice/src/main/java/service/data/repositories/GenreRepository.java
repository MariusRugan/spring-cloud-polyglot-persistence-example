package service.data.repositories;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;

import service.data.domain.Genre;

public interface GenreRepository extends JpaRepository<Genre, Long> {
  Page<Genre> findByNameContainingIgnoreCase(@Param("name")String name, Pageable pageable);
  Page<Genre> findByIdIn(@Param("ids")Long[] ids, Pageable pageable);
}
