package kopo.poly.service;

import kopo.poly.dto.NewsDTO;

public interface INewsService {

    // 기사 내용 조회하기
    NewsDTO collectNews() throws Exception;
}