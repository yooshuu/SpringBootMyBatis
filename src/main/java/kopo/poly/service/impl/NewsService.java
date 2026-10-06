package kopo.poly.service.impl;

import kopo.poly.dto.NewsDTO;
import kopo.poly.service.INewsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.stereotype.Service;


@Slf4j
@RequiredArgsConstructor
@Service
public class NewsService implements INewsService {

    @Override
    public NewsDTO collectNews() throws Exception {

        String url = "https://n.news.naver.com/mnews/article/020/0003749524";

        log.info("{}.collectNews Start!", this.getClass().getName());

        Document doc = Jsoup.connect(url).get(); // 해당 URL의 HTML 전체를 가져옴

        NewsDTO pDTO = new NewsDTO();
        pDTO.setNewsName(doc.select("#title_area").text()); // 제목 요소 텍스트 추출
        pDTO.setNewsContent(doc.select("#dic_area").text().replaceAll("●", "\n●"));

        log.info("{}.collectNews End!", this.getClass().getName());

        return pDTO;
    }
}
