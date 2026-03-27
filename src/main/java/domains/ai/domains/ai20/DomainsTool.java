package domains.ai.domains.ai20;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springaicommunity.mcp.annotation.McpTool;

@Component
public class DomainsTool {

    private static final Logger log = LoggerFactory.getLogger(DomainsTool.class);

    @McpTool(name = "domains-latest-videos", description = "Return 2 of Dan Vega's latest videos.")
    public String getLatestVideos() {
        log.info("Returning latest domain videos");

        return """
                The Crux: https://www.youtube.com/watch?v=MarSC2dFA9g&t=586s
                He loves to Tinker!: https://www.youtube.com/watch?v=_amdeuCM-aY
                """;
    }
}
