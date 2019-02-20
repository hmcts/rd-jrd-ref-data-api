package uk.gov.hmcts.reform.jrdrefdataapi.domain.service;

import uk.gov.hmcts.reform.jrdrefdataapi.domain.entities.SystemRefData;

public interface ResourceRetriever<T extends SystemRefData> {

    T getResource(String id);

}
