package io.ssafy.mallook.domain.script.application;

import com.theokanning.openai.completion.CompletionRequest;
import com.theokanning.openai.completion.chat.ChatCompletionRequest;
import com.theokanning.openai.completion.chat.ChatCompletionResult;
import com.theokanning.openai.service.OpenAiService;
import io.ssafy.mallook.domain.chatgpt.dto.request.QuestionAnswerDto;
import io.ssafy.mallook.domain.chatgpt.dto.response.GptResponseDto;
import io.ssafy.mallook.domain.chatgpt.service.GptService;
import io.ssafy.mallook.domain.keyword.entity.Keyword;
import io.ssafy.mallook.domain.member.dao.MemberRepository;
import io.ssafy.mallook.domain.member.entity.Member;
import io.ssafy.mallook.domain.script.dao.ScriptRepository;
import io.ssafy.mallook.domain.script.dto.request.ScriptCreatDto;
import io.ssafy.mallook.domain.script.dto.request.ScriptDeleteListDto;
import io.ssafy.mallook.domain.script.dto.response.ScriptDetailDto;
import io.ssafy.mallook.domain.script.dto.response.ScriptListDto;
import io.ssafy.mallook.global.common.code.ErrorCode;
import io.ssafy.mallook.global.exception.BaseExceptionHandler;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.joining;

@Service
@RequiredArgsConstructor
@Log4j2
@Transactional(readOnly = true)
public class ScriptServiceImpl implements ScriptService {

    private final MemberRepository memberRepository;
    private final ScriptRepository scriptRepository;
    private final GptService gptService;

    @Override
    public Long getMaxScriptId() {
        return scriptRepository.findMaxId();
    }

    @Override
    public Slice<ScriptListDto> getScriptList(Long cursor, UUID id, Pageable pageable) {
        Member proxyMember = memberRepository.getReferenceById(id);

        return scriptRepository.findByIdLessThanAndMemberOrderByIdDesc(cursor, proxyMember, pageable)
                .map(ScriptListDto::toDto);
    }

    @Override
    public ScriptDetailDto getScriptDetail(Long scriptId) {
        return scriptRepository.findById(scriptId)
                .map(ScriptDetailDto::toDto)
                .orElseThrow(() -> new BaseExceptionHandler(ErrorCode.NOT_FOUND_SCRIPT));
    }

    @Override
    @Transactional
    public void createScript(ScriptCreatDto scriptCreateDto, UUID id) {
        Member proxyMember = memberRepository.getReferenceById(id);
        String scriptContent = String.join(", ", scriptCreateDto.keywordsList()) + " 코디라는 단어를 합쳐서 문장을 예쁘게 만들어줘";
        System.out.println("문장: " + scriptContent);
        QuestionAnswerDto questionAnswerDto = QuestionAnswerDto.builder()
                .content(scriptContent)
                .build();
        GptResponseDto gptResponseDto = gptService.askQuestion(questionAnswerDto);
        System.out.println("응답: "+gptResponseDto.answer());
        scriptRepository.save(scriptCreateDto.toEntity(proxyMember, gptResponseDto.answer()));
    }

    @Override
    @Transactional
    public void deleteScript(ScriptDeleteListDto scriptDeleteListDto) {
        log.info(scriptDeleteListDto.toString());
        scriptRepository.deleteScript(scriptDeleteListDto.toDeleteList());
    }
}
