import 'dart:io';
import 'dart:math';

abstract class Unit {
  String name;
  int hp;
  int attack;
  int defense;

  Unit(this.name, this.hp, this.attack, this.defense);

  bool isAlive() => hp > 0;
}

class Character extends Unit {
  Character(String name, int hp, int attack, int defense)
    : super(name, hp, attack, defense);

  void attackTo(Monster monster) {
    int damage = attack - monster.defense;
    damage = damage > 0 ? damage : 0;
    monster.hp -= damage;
    print('[${name}]의 공격! → [${monster.name}]에게 ${damage} 데미지를 입혔습니다.');
    print('[${monster.name}] 상태: HP=${monster.hp}');
  }

  void defend() {
    defense += 2;
    print('[${name}]이 방어 자세를 취합니다. (방어력 +2)');
  }

  void endTurn() {
    defense -= 2;
  }
}

class Monster extends Unit {
  int maxAttack;

  Monster(String name, int hp, int maxAttack)
    : maxAttack = maxAttack,
      super(name, hp, 0, 0); // 공격력/방어력은 고정

  int generateAttack(int characterDefense) {
    int raw = Random().nextInt(maxAttack);
    return max(raw, characterDefense);
  }
}

class Game {
  late Character player;
  List<Monster> monsters = [];

  void start() {
    loadCharacter();
    loadMonsters();

    while (player.isAlive() && monsters.isNotEmpty) {
      Monster monster = getRandomMonster();
      print('\n=== 새로운 몬스터 등장! ===');
      print(
        '[${monster.name}] - 체력: ${monster.hp}, 공격력: ${monster.maxAttack}\n',
      );

      bool win = battle(monster);
      if (!win) break;

      if (monsters.isEmpty) {
        print(' 모든 몬스터를 물리쳤습니다! 게임에서 승리했습니다.');
        break;
      }

      stdout.write('다음 몬스터와 싸우시겠습니까? (y/n): ');
      String? input = stdin.readLineSync();
      if (input?.toLowerCase() != 'y') {
        print('게임을 중단합니다.');
        break;
      }
    }

    if (!player.isAlive()) {
      print(' 캐릭터가 쓰러졌습니다. 게임 오버.');
    }

    saveResult();
  }

  void loadCharacter() {
    try {
      final file = File('characters.txt');
      final contents = file.readAsStringSync().trim();
      final stats = contents.split(',').map((e) => e.trim()).toList();
      if (stats.length != 3) throw FormatException('캐릭터 정보 형식 오류');

      int hp = int.parse(stats[0]);
      int atk = int.parse(stats[1]);
      int def = int.parse(stats[2]);

      String name = promptForName();
      player = Character(name, hp, atk, def);
      print('\n캐릭터를 시작합니다!');
      print('$name - 체력: $hp, 공격력: $atk, 방어력: $def');
    } catch (e) {
      print('캐릭터 정보를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  void loadMonsters() {
    try {
      final file = File('monsters.txt');
      final lines = file.readAsLinesSync();

      for (var line in lines) {
        final parts = line.split(',').map((e) => e.trim()).toList();
        if (parts.length != 3) continue;

        String name = parts[0];
        int hp = int.parse(parts[1]);
        int maxAttack = int.parse(parts[2]);

        monsters.add(Monster(name, hp, maxAttack));
      }

      if (monsters.isEmpty) throw Exception('몬스터 없음');
    } catch (e) {
      print('몬스터 정보를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  String promptForName() {
    while (true) {
      stdout.write('캐릭터 이름을 입력하세요: ');
      String? input = stdin.readLineSync();

      if (input == null || input.trim().isEmpty) {
        print('이름은 비어 있을 수 없습니다.');
        continue;
      }

      if (!RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(input)) {
        print('이름에는 특수문자나 숫자를 사용할 수 없습니다.');
        continue;
      }

      return input.trim();
    }
  }

  bool battle(Monster monster) {
    while (player.isAlive() && monster.isAlive()) {
      print('\n[1] 공격하기  [2] 방어하기');
      stdout.write('행동 선택: ');
      String? action = stdin.readLineSync();

      if (action == '1') {
        player.attackTo(monster);
      } else if (action == '2') {
        player.defend();
      } else {
        print('잘못된 입력입니다.');
        continue;
      }

      if (!monster.isAlive()) {
        print('\n[${monster.name}]을(를) 물리쳤습니다!');
        monsters.remove(monster);
        return true;
      }

      int damage = monster.generateAttack(player.defense);
      player.hp -= damage;

      print(
        '\n[${monster.name}]의 공격! → [${player.name}]은 ${damage} 데미지를 받았습니다.',
      );
      print(
        '[${player.name}] 상태: HP=${player.hp} / ATK=${player.attack} / DEF=${player.defense}',
      );

      player.endTurn();
    }

    return false;
  }

  Monster getRandomMonster() {
    final rand = Random();
    return monsters[rand.nextInt(monsters.length)];
  }

  void saveResult() {
    stdout.write('결과를 저장하시겠습니까? (y/n): ');
    String? input = stdin.readLineSync();
    if (input?.toLowerCase() == 'y') {
      final file = File('result.txt');
      final result = player.isAlive() ? '승리' : '패배';
      final content = '이름: ${player.name}, 남은 체력: ${player.hp}, 결과: $result';
      try {
        file.writeAsStringSync(content);
        print('결과가 result.txt에 저장되었습니다.');
      } catch (e) {
        print('결과 저장 실패: $e');
      }
    }
  }
}

void main() {
  Game game = Game();
  game.start();
}
