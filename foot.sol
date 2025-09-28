/**
 *Submitted for verification at basescan.org on 2025-01-17
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FootballerAttack {
    // Structure pour représenter un joueur de football
    struct Footballer {
        string name;
        uint energy;
        uint attackPower;
    }

    // Mapping pour stocker les joueurs par adresse
    mapping(address => Footballer) public footballers;

    // Événements pour suivre les actions
    event FootballerRegistered(address player, string name);
    event AttackMade(address attacker, address defender, uint damage);

    // Fonction pour inscrire un nouveau joueur de football
    function registerFootballer(string memory name, uint attackPower) public {
        require(bytes(name).length > 0, "Le nom ne peut pas etre vide.");
        require(attackPower > 0, "La puissance d'attaque doit etre superieure a 0.");

        footballers[msg.sender] = Footballer({
            name: name,
            energy: 100, // Énergie initiale
            attackPower: attackPower
        });

        emit FootballerRegistered(msg.sender, name);
    }

    // Fonction pour attaquer un autre joueur
    function attack(address defender) public {
        Footballer storage attacker = footballers[msg.sender];
        Footballer storage target = footballers[defender];

        require(bytes(attacker.name).length > 0, "Attaquant non enregistre.");
        require(bytes(target.name).length > 0, "Defenseur non enregistre.");
        require(attacker.energy > 0, "L'attaquant n'a plus d'energie.");
        require(target.energy > 0, "Le defenseur n'a plus d'energie.");

        uint damage = attacker.attackPower;
        if (damage > target.energy) {
            damage = target.energy; // Limite les degats a l'energie restante
        }

        target.energy -= damage;

        emit AttackMade(msg.sender, defender, damage);
    }

    // Fonction pour consulter l'état d'un joueur
    function getFootballerStatus(address player) public view returns (string memory, uint, uint) {
        Footballer memory footballer = footballers[player];
        return (footballer.name, footballer.energy, footballer.attackPower);
    }
}
