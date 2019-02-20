package uk.gov.hmcts.reform.jrdrefdataapi.domain.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import uk.gov.hmcts.reform.jrdrefdataapi.domain.entities.Country;

@Service
public class CountryResourceRetriever implements ResourceRetriever {

    private JdbcTemplate jdbcTemplate;

    public CountryResourceRetriever(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public Country getResource(String id) {

        final String query = "SELECT country_name FROM country WHERE id = ?";

        String countryName =
            jdbcTemplate.queryForObject(query, new Object[]{id}, String.class);

        return new Country(id, countryName);

    }
}
