package uk.gov.hmcts.reform.jrdrefdataapi.infrastructure.controllers;

import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import javax.validation.constraints.NotNull;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import uk.gov.hmcts.reform.jrdrefdataapi.domain.entities.SystemRefData;
import uk.gov.hmcts.reform.jrdrefdataapi.domain.service.ResourceRetriever;

@RequestMapping(
    path = "/sysrefdata",
    consumes = MediaType.APPLICATION_JSON_UTF8_VALUE,
    produces = MediaType.APPLICATION_JSON_UTF8_VALUE
)
@RestController
public class SysRefDataController {

    private ResourceRetriever resourceRetriever;

    public SysRefDataController(ResourceRetriever resourceRetriever) {
        this.resourceRetriever = resourceRetriever;
    }

    @ApiOperation("Retrieves all country reference data")
    @ApiResponses({
        @ApiResponse(
            code = 200,
            message = "Representation of all country reference data",
            response = String.class
        )
    })
    @GetMapping(
        path = "/countries/{id}",
        produces = MediaType.APPLICATION_JSON_UTF8_VALUE
    )
    @ResponseBody
    public ResponseEntity<SystemRefData> getCountry(@NotNull @PathVariable String id) {

        return ResponseEntity.ok(resourceRetriever.getResource(id));

    }
}
