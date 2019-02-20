package uk.gov.hmcts.reform.sysrefdataapi;

import static org.springframework.boot.test.context.SpringBootTest.WebEnvironment.MOCK;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.webAppContextSetup;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.context.WebApplicationContext;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class, webEnvironment = MOCK)
public class CountrySysRefDataTest {

    private MockMvc mockMvc;

    private static final String APP_BASE_PATH = "/sysrefdata";

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Before
    public void setUp() {
        this.mockMvc = webAppContextSetup(webApplicationContext).build();
    }

    @Test
    public void should_get_status_200_when_get_country_by_id() throws Exception {

        sendGetRequest(APP_BASE_PATH + "/countries/1", MediaType.APPLICATION_JSON, HttpStatus.OK.value());

    }

    @Test
    public void should_get_status_404_when_get_country_by_id_that_is_not_in_db() throws Exception {

        sendGetRequest(APP_BASE_PATH + "/countries/2", MediaType.APPLICATION_JSON, HttpStatus.NOT_FOUND.value());

    }

    private void sendGetRequest(final String path,
                                final MediaType mediaType,
                                final int expectedHttpStatus) throws Exception {

        mockMvc.perform(get(path)
            .contentType(mediaType))
            .andExpect(status().is(expectedHttpStatus)).andReturn();
    }


}
