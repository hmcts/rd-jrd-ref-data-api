package uk.gov.hmcts.reform.jrdrefdataapi.infrastructure.serialization;

public interface Deserializer<T> {

    T deserialize(String source);
}
