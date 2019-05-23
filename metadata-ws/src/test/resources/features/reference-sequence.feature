Feature: reference sequence

  Scenario: register a reference sequence successfully
    Given I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606,
      "name": "Homo Sapiens"
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accessions": ["GCA_000001405.3", "GCF_000001405.14"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then set the URL to REFERENCE_SEQUENCE
    And the response code should be 201
    And the Location header should be present with value of REFERENCE_SEQUENCE
    When I request GET with value of REFERENCE_SEQUENCE
    Then the response code should be 200
    And the response JSON should be:
    """
    {
      "name": "GRCh37",
      "patch": "p2",
      "accessions": ["GCA_000001405.3", "GCF_000001405.14"],
      "type": "ASSEMBLY"
    }
    """
    When I request GET /reference-sequences
    Then the response should contain one reference sequence


  Scenario Outline: find one reference sequence by name
    Given I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606,
      "name": "Homo Sapiens"
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accessions": ["GCA_000001405.3", "GCF_000001405.14"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then the response code should be 201
    And set the URL to REFERENCE_SEQUENCE_1
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh38",
      "patch": "p2",
      "accessions": ["GCA_000001405.17", "GCF_000001405.28"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then the response code should be 201
    And set the URL to REFERENCE_SEQUENCE_2
    When I request search for the reference-sequences with the parameters: <query>
    Then the response code should be 200
    And the response should contain one reference sequence
    And the href of the referenceSequence of reference-sequences has items <url>
    And the <field1> field of reference-sequences 0 should be <value1>
    And the <field2> field of reference-sequences 0 should be <value2>

    Examples:
      | query | url | field1 | value1 | field2 | value2 |
      | name=GRCh37 | REFERENCE_SEQUENCE_1 | name | GRCh37 | patch | p2 |
      | name=GRCh38 | REFERENCE_SEQUENCE_2 | name | GRCh38 | patch | p2 |
      | name=GRCh37&patch=p2 | REFERENCE_SEQUENCE_1 | name | GRCh37 | patch | p2 |
      | name=GRCh38&patch=p2 | REFERENCE_SEQUENCE_2 | name | GRCh38 | patch | p2 |
      | name=GRCh37&patch=p2&accessions=GCA_000001405.3 | REFERENCE_SEQUENCE_1 | name | GRCh37 | patch | p2 |


  Scenario Outline: find one reference sequence by accession
    Given I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606,
      "name": "Homo Sapiens"
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accessions": ["GCA_000001405.3", "GCF_000001405.14"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then the response code should be 201
    And set the URL to REFERENCE_SEQUENCE_1
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh38",
      "patch": "p2",
      "accessions": ["GCA_000001405.17", "GCF_000001405.28"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then the response code should be 201
    And set the URL to REFERENCE_SEQUENCE_2
    When I request search for the reference-sequences with the parameters: <query>
    Then the response code should be 200
    And the response should contain one reference sequence
    And the href of the referenceSequence of reference-sequences has items <url>
    And the accessions field of reference-sequences 0 should have item <contained_accession>

    Examples:
      | query | url | contained_accession |
      | accessions=GCA_000001405.3 | REFERENCE_SEQUENCE_1 |  GCA_000001405.3 |
      | accessions=GCF_000001405.28 | REFERENCE_SEQUENCE_2 |  GCF_000001405.28 |
      | patch=p2&accessions=GCA_000001405.3 | REFERENCE_SEQUENCE_1 |  GCA_000001405.3 |


  Scenario Outline: find one reference sequence by type
    Given I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606,
      "name": "Homo Sapiens"
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "BRCA1",
      "patch": "3",
      "accessions": ["NM_007294.3"],
      "type": "GENE",
      "taxonomy": "TAXONOMY"
    """
    Then the response code should be 201
    And set the URL to REFERENCE_SEQUENCE_1
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh38",
      "patch": "p2",
      "accessions": ["GCA_000001405.17", "GCF_000001405.28"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then the response code should be 201
    And set the URL to REFERENCE_SEQUENCE_2
    When I request search for the reference-sequences with the parameters: <query>
    Then the response code should be 200
    And the response should contain one reference sequence
    And the href of the referenceSequence of reference-sequences has items <url>
    And the type field of reference-sequences 0 should be <type>

    Examples:
      | query | url | type |
      | type=GENE | REFERENCE_SEQUENCE_1 | GENE |
      | type=ASSEMBLY | REFERENCE_SEQUENCE_2 | ASSEMBLY |


  Scenario Outline: find zero reference sequence
    Given I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 9606,
      "name": "Homo Sapiens"
    }
    """
    Then set the URL to TAXONOMY
    And the response code should be 201
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accessions": ["GCA_000001405.3", "GCF_000001405.14"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then the response code should be 201
    And set the URL to REFERENCE_SEQUENCE_1
    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh38",
      "patch": "p2",
      "accessions": ["GCA_000001405.17", "GCF_000001405.28"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY"
    """
    Then the response code should be 201
    And set the URL to REFERENCE_SEQUENCE_2

    When I request search for the reference-sequences with the parameters: <query>
    Then the response code should be 200
    And the response should contain 0 reference-sequences

    Examples:
      | query |
      | name=NCBI36 |
      | name=NCBI36&patch=p2 |
      | name=GRCh37&patch=p3 |
      | name=GRCh38&patch=p3 |
      | accessions=GCA_000001405.2 |
      | name=GRCh37&patch=p3&accessions=GCA_000001405.3 |
      | type=GENE |
      | type=TRANSCRIPTOME |


  Scenario: find reference sequence by invalid type should fail
    When I request search for the reference-sequences with the parameters: type=UNKNOWN
    Then the response code should be 4xx


  Scenario: register a reference sequence and update taxonomy successfully
    Given I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 1,
      "name": "Species1"
    }
    """
    Then set the URL to TAXONOMY1
    And the response code should be 201

    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accessions": ["GCA_000001405.3", "GCF_000001405.14"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY1"
    """
    Then set the URL to REFERENCE_SEQUENCE
    And the response code should be 201

    When I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 2,
      "name": "Species2"
    }
    """
    Then set the URL to TAXONOMY2
    And the response code should be 201

    When I request GET for taxonomy of REFERENCE_SEQUENCE
    Then the response code should be 200
    And the href of the class taxonomy should be TAXONOMY1

    When I request PATCH REFERENCE_SEQUENCE with taxonomy TAXONOMY2
    Then the response code should be 2xx
    When I request GET for taxonomy of REFERENCE_SEQUENCE
    Then the response code should be 200
    And the href of the class taxonomy should be TAXONOMY2


  Scenario: register a reference sequence without taxonomy and fail
    When I request POST /reference-sequences with JSON payload:
    """
    {
      "name": "GRCh37",
      "patch": "p2",
      "accessions": ["GCA_000001405.3", "GCF_000001405.14"],
      "type": "ASSEMBLY"
    }
    """
    And the response should contain error message A reference sequence must have one valid URL to taxonomy
    Then the response code should be 4xx

    Scenario: register a reference sequence with invalid taxonomy and fail
    When I request POST /reference-sequences with JSON payload:
    """
    {
      "name": "GRCh37",
      "patch": "p2",
      "accessions": ["GCA_000001405.3", "GCF_000001405.14"],
      "type": "ASSEMBLY",
      "taxonomy": "http://nohost/taxonomy/999"
    }
    """
    And the response should contain error message A reference sequence must have one valid URL to taxonomy
    Then the response code should be 4xx


  Scenario: update a reference sequence with invalid taxonomy and fail
    Given I request POST /taxonomies with JSON payload:
    """
    {
      "taxonomyId": 1,
      "name": "Species1"
    }
    """
    Then set the URL to TAXONOMY1
    And the response code should be 201

    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accessions": ["GCA_000001405.3", "GCF_000001405.14"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY1"
    """
    Then set the URL to REFERENCE_SEQUENCE
    And the response code should be 201

    When I request PATCH REFERENCE_SEQUENCE with content {"taxonomy": "http://nohost/taxonomy/999"}
    And the response should contain error message A reference sequence must have one valid URL to taxonomy
    Then the response code should be 4xx


  Scenario Outline: search various reference sequences by taxonomy name and id
    When I request POST taxonomies with 207598 for ID, Homininae for name and NONE for ancestors
    Then set the URL to TAXONOMY_1
    When I request POST taxonomies with 9606 for ID, Homo Sapiens for name and TAXONOMY_1 for ancestors
    Then set the URL to TAXONOMY_2
    When I request POST taxonomies with 9596 for ID, Pan for name and TAXONOMY_1 for ancestors
    Then set the URL to TAXONOMY_3
    When I request POST taxonomies with 9597 for ID, Pan paniscus for name and TAXONOMY_1,TAXONOMY_3 for ancestors
    Then set the URL to TAXONOMY_4
    When I request POST taxonomies with 9598 for ID, Pan troglodytes for name and TAXONOMY_1,TAXONOMY_3 for ancestors
    Then set the URL to TAXONOMY_5

    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh37",
      "patch": "p2",
      "accessions": ["GCA_000001405.3", "GCF_000001405.14"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY_2"
    """
    Then set the URL to REFERENCE_SEQUENCE1

    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh38",
      "patch": "p2",
      "accessions": ["GCA_000001405.3", "GCF_000001405.14"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY_4"
    """
    Then set the URL to REFERENCE_SEQUENCE2

    When I request POST /reference-sequences with JSON-like payload:
    """
      "name": "GRCh39",
      "patch": "p2",
      "accessions": ["GCA_000001405.3", "GCF_000001405.14"],
      "type": "ASSEMBLY",
      "taxonomy": "TAXONOMY_5"
    """
    Then set the URL to REFERENCE_SEQUENCE3

    When I request elaborate search for the reference-sequences base <base> and with the parameters: <query>
    Then the response code should be 200
    And the response should contain <N> reference-sequences
    And the href of the referenceSequence of reference-sequences has items <url>

    Examples:
      | base | query | N | url |
      | taxonomy-id | id=9606 | 1 | REFERENCE_SEQUENCE1 |
      | taxonomy-id | id=9596 | 2 | REFERENCE_SEQUENCE2,REFERENCE_SEQUENCE3 |
      | taxonomy-id | id=207598 | 3 | REFERENCE_SEQUENCE1,REFERENCE_SEQUENCE2,REFERENCE_SEQUENCE3 |
      | taxonomy-id | id=0 | 0 | NONE |
      | taxonomy-name | name=Homo sapiens | 1 | REFERENCE_SEQUENCE1 |
      | taxonomy-name | name=Pan | 2 | REFERENCE_SEQUENCE2,REFERENCE_SEQUENCE3 |
      | taxonomy-name | name=Homininae | 3 | REFERENCE_SEQUENCE1,REFERENCE_SEQUENCE2,REFERENCE_SEQUENCE3 |
      | taxonomy-name | name=None | 0 | NONE |