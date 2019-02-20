package uk.gov.hmcts.reform.jrdrefdataapi.infrastructure.security;

import java.util.Map;

public interface AccessTokenDecoder {

    Map<String, String> decode(
        String accessToken
    );
}
