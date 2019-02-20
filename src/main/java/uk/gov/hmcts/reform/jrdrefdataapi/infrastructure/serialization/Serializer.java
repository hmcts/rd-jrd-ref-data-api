package uk.gov.hmcts.reform.jrdrefdataapi.infrastructure.serialization;

public interface Serializer<T> {

    String serialize(T data);
}
