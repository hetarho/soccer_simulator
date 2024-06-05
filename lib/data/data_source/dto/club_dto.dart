import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:soccer_simulator/data/data_source/json_converters/color_json_converter.dart';
import 'package:soccer_simulator/data/data_source/json_converters/tactics_json_converter.dart';
import 'package:soccer_simulator/domain/entities/tactics/tactics.dart';
import 'package:soccer_simulator/domain/enum/national.enum.dart';

part 'club_dto.freezed.dart';
part 'club_dto.g.dart';

@freezed
class ClubDto with _$ClubDto {
  const factory ClubDto({
    required int id,
    required int leagueId,
    required National national,
    required String name,
    required String nickName,
    @ColorJsonConverter() required Color homeColor,
    @ColorJsonConverter() required Color awayColor,
    @TacticsJsonConverter() required Tactics tactics,
    required int winStack,
    required int noLoseStack,
    required int loseStack,
    required int noWinStack,
  }) = _ClubDto;

  factory ClubDto.fromJson(Map<String, dynamic> json) => _$ClubDtoFromJson(json);
}
