package io.ssafy.mallook.domain.script.dto.request;

import io.ssafy.mallook.domain.keyword.entity.Keyword;
import io.ssafy.mallook.domain.member.entity.Member;
import io.ssafy.mallook.domain.script.entity.Script;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Builder;

import java.util.List;

@Builder
public record ScriptCreatDto(
        @NotEmpty
        List<String> keywordsList) {

    public Script toEntity(Member member, String scriptContent) {
        return Script.builder()
                .name(scriptContent)
                .member(member)
                .heartCount(0)
                .totalLike(0)
                .build();
    }

    public Keyword toKeyword(Script script, String name) {
        return Keyword.builder()
                .script(script)
                .name(name)
                .build();
    }
}
