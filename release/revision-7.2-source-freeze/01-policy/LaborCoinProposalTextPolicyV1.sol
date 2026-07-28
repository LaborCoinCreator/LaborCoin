// SPDX-License-Identifier: MIT
pragma solidity 0.8.36;

/// @title LaborCoin Proposal Text Policy V1
/// @notice Immutable lexical policy for permanent LaborCoin proposal text.
/// @dev
/// This contract is deliberately deterministic and administrator-free.
/// It rejects non-ASCII text, markup delimiters, obvious URL schemes,
/// prohibited normalized tokens, prohibited two- and three-token phrases,
/// punctuation-separated spellings, common numerical substitutions, and
/// sequences composed of separated single letters.
///
/// It is a lexical safeguard, not a semantic language model. No finite
/// immutable denylist can recognize every hateful implication or every novel
/// obfuscation. The exact policy and its limitations are publicly committed.
contract LaborCoinProposalTextPolicyV1 {
    uint256 public constant MIN_DESCRIPTION_BYTES = 1;
    uint256 public constant MAX_DESCRIPTION_BYTES = 1_000;

    uint256 public constant TOKEN_HASH_COUNT = 143;
    uint256 public constant PHRASE_HASH_COUNT = 18;

    bytes32 public constant COMPATIBILITY_ID =
        keccak256(
            "LABORCOIN_PROPOSAL_TEXT_POLICY_V1_ASCII_HASHED_LEXICON"
        );

    bytes32 public constant LEXICON_COMMITMENT =
        0x46c24360a194d5e60f247daaee4f554032282ae90098a4b35662395bf4a3d2a6;

    string public constant POLICY_VERSION =
        "LaborCoin Proposal Text Policy V1.0.1";

    uint256 private constant _NO_INDEX = type(uint256).max;

    struct ScanContext {
        bytes normalized;
        bytes tokenTable;
        bytes phraseTable;
        bytes singletonSequence;
        uint256 normalizedLength;
        uint256 tokenStart;
        uint256 previousStart;
        uint256 previousEnd;
        uint256 twoBackStart;
        uint256 twoBackEnd;
        uint256 singletonLength;
    }

    bytes private constant _BLOCKED_TOKEN_HASHES =
        hex"06b6d3d08d656a80d041c57d34c869eabef6fa1b61b3fff07ebb00cbaf6eb17607c33feef38b0900ac83cbb3ead045b1e78b7b9f0a31321958d2a716abf0a90009c9a2fa5572a53056ee33cb64169b1b24a06126506209a9d0eed3fbfbc5108109d4a54665c864fc7d55622e7952d19fc569b359c001eb97d97dde58532e5e010a24abaf1958a8bb97cc5a42b6e8e716776df627294e283c5b79c48614478fea0a94fd1bcabfd728d386de8b2e1d94f4cbce9b8d0286105239acb929d8a298fd0b7d039608f73b7e8dd2a529c9de0c23457db674fb965821167d8008cb51428e0fe9b15acca09ff0c99c1ecc3c8162e6adf0125caeb9ae297090598ef7def1d8127c7669dcd7d6ca173bf50da5014ad440200af7b3220c52e4686e2132a5aa0e1378f5933c788896d61f327b01f31cfb4e968b257f0806bf7a11b0841274d36d13fd990a341946094b052ef6036a06ce9e0fab7dc5826083018b8e243fbba57e1ce04c8fbc5a0f97bb9b363c9af5c70247cdf4c45fa39bf57774b76ef9a339531ffe4c45651294fcf4a4a698ec3de27bed969436f3f33729e471833f620b60a2229ef887af01baa1353ea59f34d9cac9ac833078c471b2caf61d0485e7e762df239477731044ef3aa6a2b5902d50be8cb93beecd659bbb3cd976c7b958b5e6c32543e315093ed53667cca6877ffbc558cb45a14c8d02cce313fa67a694574b7e26383d6f7bafc00783615588a0dc8fd8375925af5a5c88b1915b80e41406f16c2663ad8b7c4a0cf2bff889181d195381a043c512716163b62ef42cc6c956bc2326a54d859003c49ea00384498c11dd9f3ec99d4b56b89b90662e6b16ea12bfbf29a7feba0eb9aa7a9ff0629c587bba360fd7c19cd2db1ef2e63ff33f0ac014092a2d7200a9f9961f4a678ea6988071cf1b5e1bd0a6864b99172fba05be6ebc9c2bd55b20d9ad119a7b4c09a22bac970eea7dc3cd97d3ec2658c46af2da641fe22e66368e61a7e2e38ce78966a2b5951147293068b55cea88cc51d4b3daa5ad132feee4f77d8dc8cfdd885539220055ba4ae3fefef244c8887b6a5289a2a07834300665018b91db2753c693f6c043ce3474c8bf42d85f1e8125eadfd1031cf14f301462c76e3bd5f47fb9069835508a01def0b8f8a70fe4eca682c7f8d43b3f903217da3e99411b86da28fd2b5eaf2e396b1bed6b3f4fc5258dddc23be2b3113533ffae5b80e80d931c9116d57e105fe4c2440a53aff1c478e894d4943b3eadb9342a2787b9188f32287d2041b88cd64d3ebdd0ba0b7358826d2d1a46aaa2cbde35fe23c25b24fb956c10084475091f56980077f653d6efe542b1fab4d002a47136069c13481152ed64bd5b261c476b5e8ecdf37020491781a790d7aa61dfef4a399aad4e6710f503ba8e2e175b192d6c741e56f438f4467709fd667855a131993c715254f15bc6459c8c207e3294b92c6beeca177652a78c59eaa638c3d2db974027dcf95b454fc644f519397601c4a71fdb30db305c1b2efce15fda9b28cb2041ff4e55e8ef87df1e3ae13829220f1ba00fcd1ae2cd174bfaa85707de5f862942d05edbc51cd0d5cf3670136d9ed987462952ce42519cc593487e400c724e9643fb50b5e353ab8e49b620d2d7089b2df56b557de4f895c47a9852d5c7fb308044f349bfcbe277617d6ce15b5e9a66324d32d68b00ddfb6af68e6ea5aecf31ca45733c7e75aa7e359f6723cfd418d3fac0f9c6b5b8ca64e98def7fa1687266c34d2a493ecfd1e05f73a29085a9f321665f30a3042f46f47f187e8589abe7db914ebd36a92b6d0685d294e7b494384ab3ee015ee8657b78bb6e4af4efa4d8d9fd50a285ff110494a891b94b14ba7ee7512a4626304645ad98aa1127d5349d787f5135780da691cf1309179aae891e8318b93ddca90f36bdff5a001703657295835193a25ca2ce342a9b7810f192c50190d222edf5be82bd6c0a5f2c5a77d6e40651eb1335dc21fa95fc7311b0647ae4cbb9a318051e5bd172cd945a1f25bd22495366b231e5ebd057d449eb9fe6a511b00a705c79d33db7ea085f33676998b01b550c42b3016ab6c5239035ce88cb2fcb005a75f76326667fe6d0b8b9a5126c705b417940b45af139db76cf8e04252a8b53927c1785685292974ebaf2609ec65f5ccb8b51a374094e2d727c7d61a99af01e6deb1cddc1f4fd857d0f098921da7a5f645425358f15ecbe395238e1ddd36276b8e3b6aee822855456c26d0364761d60be70fd95d736ec9f3e80d91ebacf5dd5378283b5111b1ef36246225b306919659ae36e73037d746d93bd3e640aaddc2d5096a0040656f115996c6ade25393c6db2f1429e744f5d653af9cb4729948611a74cfefe454ac4edade3329cc63cd46de45ae9c8d973c6d360a3ca6ce92480c2e04e93bafbaff4f7310bf8483d1c826e83163ee5e06b3e0d0e4570645f191d21e301f11368b292f5483efabcd013676f56674efa535f4b9278c740529acfcb047522e553e05e6970fe16cdf716eb4e707249d5b9f140166491e0364d0dae577d32d9152e9bb206ca3300537f73becd7079780578fae87c05e791084766f441466f4b64bcaea0041fcb210826e784ed726c0062bdcce9222bc4bbdc6145e6ca6cc8298b2241a932f752003f85a7a4e773933a39ddbf23cef8a16fea4b87097fa370f20d8111f448a122a3ae6ad262657959cf42e36454e00354b08197824af3b345e4970446ae6cab6cae1c3667ad93798656cdcebe53de47f4f0f89f333910492522e2a1850f52b4524b97c6fb93767ac25f4a43423bf839302e7c762d62bd4363267f6536da665f4d24d76ff04d767dc9623b36496b70df17a223b276c1221d2cd2a4a8edb4861fe9a86a80f5bc8f7e504bb34f1f8b1107f362009631cd8d4715f65d3eb053c83e0cb0aa91c0f0028123fa3a85e081af19278a74fb94d738d423304532299088a33bdbe774d55c6e829f5b6033030772523b9c8ce9de6814249ca119384acf17b7eba33d7777a40785d9cfea202dd42998feff5fdbde14867d3b72d72cec9524617b1d1494a4d404868d34bd658705e54140e4cba75e8b5b28023a28b9ed09a30fea983632fadc8f8d3505dca15261118da7147bd095c90cde09f567ea16a4598227cd18965881408efeeea4b6df081b8a67ddbf3fd208bd4b49e4e1fcd6a98b67b75d7343380a738fede48917089b84482cb243b64c757aab3e8e3c94fd607485e3250332602a1490e3b6c58dffe3d0f4e50960ddd4810b0c2e1174897a2420988c0b150cdb7a0e919ed8093e456ddb51b6f990c449d570ca6c3608c7d1c019a9772de8054b145692e6130adf796f9bc410ad3bb49472b45d8d2a35adc618491d50819a5034a79693247a8c8719fd37d6194209f2e0bed091be49dd813652028fd45e0c0181670f93c18f45a289ce14d3c52fad4173d29c77358b68797b49f4bdfbd1e6028258f1945c085257f22408de7d3c53da2c842155eaa9f81a13741521c69394c43e1b4096b5eefb14b07e3e48b381a5bd8ae9a7ae8abfbbea24a4e1d08c59db4a61839996cb925c5fb3c5a8ee048726213c29d44efd07a41d6820254f4a74fc35d4122599ce643741ed5ed704023ac373f15ddf56eee068dd09287e3a43e7ec77e37e929c3c475d27c858f6f3eaf328062d6eb475d726e68bc1ecc250e8b955165dac439cbef10937917e1ccd9902b237e5dc47df7d247a622e705f7f1cf973c7ebc87a9edc554a6737cb2a2fd3f7423d858e0d07d959c51462f0fee60fe8cd048b01e99fb603c2f7603abb5aefc6e211b1aaaad28ec6e7310c1f34a26ea43809d282b6a0907cd33c3a792143af07a05c1f5f225277a0b56625e24c41811b9dbd7a3fc5a23be3aa74fb33908e43a496a68952311e591d103d920319ff16c0e3beb5ae6da3483cb597b213946221070d0a69d88e69b9773071472e3148f203b0da2047e3a4833822a49a410f57dfe6ce9b52df0ffa3a47a627aaab30a95a9e7f349c31f5a4ae0ae0345d7514b6385895eb5b7973f796ab4de92bd8670f31d3a180a1f23da85ec2ba30f5023eb0d2ad2a3597c0315f255f662d32d9646084340ef2e56c3da95670e3f46a9fab608fb86d36b8c64218aac67c56900ff8e51f1cbd44fd20ecb02e94dfeb31fdf44c4ca042b1daeba8b49374d20609dc5a96106912f65e1f3bb223e7f83a885fc486ab1676ce2ae7d4836b30223b64cc06afbd713677b513beb3d57f47f23119ac150141d3e218d02dd098c6c8b71a1cfe1e7f4e3e6d8fd4b8b61dd99184eb8fb611c13c45a9d153ac55b797d3cf7745c018fc66e201403252b6f6d0e6b6209171e360176e3aee6d2040beae3315d719a43940e8fcb725b3aeba58d1f405cbbc25c28b14da5e0946f6b9f908b2813d956a4d74513f532fafc9bc4ba4d94124907489878fa64841d79b3b4616db7e6a078044d13229d2f52e5cbcf2d8393f8ced3e964b0cb6d64b539a5248c9a4f3e525cda0f2df172db1b108c367f6f6322c5f55d53380f5b1068841d3e4251b7021bb2954a41ea5d1ba6ae3c375a7cd2e5ee76cdf9507c3670ef3820dab5bf48016f0d3f84ed7becb7fec5dc5cc925979cd8b4b84c886f480e62af15083bdc031f9cc8742d49a4ad37fd134c9f1f26c2e1efaa0acd22ab8ff4e58acc79df733a6e9ae3d7fd3496d63d01f60cbd7b8d54efc7f246349e35b3e0b1902e0d1f6aa66a83c2264c307c77506658ad016446c7313676ce688e0e63fb57eb81fad39b993754c906f99d364e975f2dbd0d4b129e6e93c3dd433cb5a847cfc47e2e93aa399aa0c68e8f5b65e58daec9fd1a57625bf378ac916b464d3df62a0b6e809e66336ae3e8a5fc05a0b07ec3324d4c749551c4eff92ebfaafef3c517fd784f9bc35bf9566fc5d0ab701dd021204d517e7baa07da21c69d9de1328bf036c6d46e4f6001ee9bb21c2432c41e68c25d66db2a8ddd08f5c3fb56abe02a72310c9d39367a14344e691a17251e081d8e2dae1e7827fe17cb26344a748f5b2b74ae1ceaa47bdb4c4c5cfd09ce4f2c5774ede61cdab9a5c6133f3e1abc77e649cb9dd23c33ca55085fc37c398f94851bb27e167e1848b2734671487c91e289e4c12f9589c002afc579f980e5b448c6db3abe20c4af13fee819dc3fd5e8e684331044171f963a6dcecf4012ed6fdfe042d35e22daa4b3aa7c222ea761d044dd4c97face9ab996d1d458ff89e295885adc02ce42d798d9dd3d1a6f06eeaae3585761e6600096b19c45c51afad46791aae8376e4f0d3d46d8157c6ba087f19cbee92f9cc9fb1c0b2e905d17ed6af8d5166ca86e52a69d7f08f74683b06f8fdb4771bf9da7bcedd40712f8bbb600dfce5d2e495e5bc79f92f30bc2559d19c85096c5add05d3f6a2724416b2bc3a5dbb94c86d7be6605343894d423af6ec3ab0fbe4d72dbec82c6777b216dd28a7e22123a4901ae700ed3a88252900c5c12b51224deed9d0cc13bcdd093c9f079f65b128cb9eafe71399bf6ace46726e80baf8e90336297a09c98d65d91d6d070031649b5fd1eee7646be3fb2b6dbfb32561a0d1083f1ef0dd056ccd407baf2bdf3cb1adb0f549e7a154cc970b27b64ec4d4678bd823c93ad711c17e5d5cc20e87ec56b934857feb48e3a842ffe582e4342ce5e33c7f4df6b97ee4a53b10fb423376adb3adb35eec637db23a03dbd3255abd4823d3d7c1e4162544eec80d2b54dbee0f1d8e6a19ed92eeba73797150099ef9035b92e3bc3a3cd3b18da36f51385910726606e1f1ee42159bc71766eaced6644bcb49bd7d3c43f3cc121f812fa7d0b2576b7afa01f03c5751774be360ae6b33055fceaea3cdc2791772a1c8bc91e753c1c306a1bff04d0faed61eb5a3833d65408ad756f7f318b1fae076383869425e1c7bc59ff3f0b1143c59c8806524a73274b175ccd1ef6535166ba772f4cf05c8be3a011d66f36f576314de51e248d10f8694034f750cad796285497fceaaf25b9e3c12b00af58fc8f374b2bebbd1bf3d82dd0e8521a78a94786f16e37461d7376af240dde9f5ba8da751d891ac24d97929da48adc16eef5e614f2f5538e72bbf16bfde0d7ef61ad7ef345ac75329505ecdada43fc3759837d962b828698b6126c2b7cd1058f875f321848a7e3a3838c4757343d40b6bd35af95da8ff1e6964341d40330e16f9eef2fc83edac88aace2228f8f3f5e60f4715c7e11abbe623a7276e99a2f08efa3cbdf876239e75830f9a5583c619c07826a7eb5d2f084c22ed23ef519a6e5bfb07370921d6656c416580767f72f0895a0d0374cbc8045539c54e1e391c3742fb811c7dab65e99e7e385d9e4ec3a102891a1968ad1886da4c29b62b5e338285fbc361f939fc56d82cbe39ac9fa4c2fc16ebd1138c97c8fd794cf6071e5c92b8fbe9865987719852087d709ceb0da7ea28e14ce290a6281d6ce117ef605068ae";

    bytes private constant _BLOCKED_PHRASE_HASHES =
        hex"02c46e43997afdd7e4ac65f0ceda5b21b33042e4858d46a3953ffad61d7f7da015c7bc7a7a689f7ab2b088d1ced878192942c7bfab57bb51f9a2637c03bc593b17075b9e23d243e125722c0f5de88eb35b3ac9a15438cb74a15cb6e31b412fe4456822dc76adfc0d429b015468ee8f2db0901620c273d4ed5c5ded4de4f731cb4574583fc3c69fb2f8cb564028ecb85a49abdea4b7bd30184c01b1d2749fe4144c1183b753f05d5d73f8ae036fc0fbf4948f2be07191653214e53cc514c7ecd2510b9303f1162fdbc6ee6a8eb7926a475027de085f0fe4185aa8eb59111d350559e6061f47519e4a0feab70636f81cabf8ee7f5ce0cc123fb16718865f6c32166de627d2c25d12cbe87e8f5f19e9f9dedbb432945378d4e85af594a64979d0c16fb7f6badb13f77d6b47821627042ae0de820a8ff732c0069ef929e321e3908277950e63f865c770515e1190c51e816f7e9fe0412fcc29dec16fc34465db242980c999a5bc24e3cda9a0c7d6ed033751f53d7cc547cf7fb70efac78caf14fb3282f6556ded27b33136975ff3180272fad795f0c64249d98aa54228b4e4bce0569b43b337716a01afb750ef435671c5f1b215d2701dcad9e610c72dadd75643639d8ad4d1c8b977112fc6172893d381ba641583d43797e2e67d8b648e21a73851ca7734308729245471b233fd90492aec5dfd5f56131729947f9664981b748c95d379fc2b9bca8c1721dc12771e81f89b5138ea184ec37520dbe09751e0e65d15ee0dfc2a3b787faec0b38f604c15551cc98ffa137af8105ce474ee90f2118b41";

    uint8 private constant _VALID = 0;
    uint8 private constant _EMPTY = 1;
    uint8 private constant _TOO_LONG = 2;
    uint8 private constant _INVALID_CHARACTER = 3;
    uint8 private constant _MARKUP = 4;
    uint8 private constant _URL = 5;
    uint8 private constant _NO_WORDS = 6;
    uint8 private constant _PROHIBITED = 7;

    error EmptyDescription();
    error DescriptionTooLong(uint256 actual, uint256 maximum);
    error InvalidCharacter(uint256 index, uint8 character);
    error ProhibitedMarkup(uint256 index);
    error ProhibitedURL();
    error DescriptionHasNoWords();
    error ProhibitedLanguage();

    /// @notice Reverts unless the description satisfies the permanent policy.
    /// @return contentHash Keccak-256 of the exact accepted description bytes.
    function validateDescription(
        string calldata description
    ) external pure returns (bytes32 contentHash) {
        bytes memory raw = bytes(description);
        (uint8 code, uint256 detail) = _scan(raw);

        if (code == _EMPTY) revert EmptyDescription();
        if (code == _TOO_LONG) {
            revert DescriptionTooLong(
                raw.length,
                MAX_DESCRIPTION_BYTES
            );
        }
        if (code == _INVALID_CHARACTER) {
            revert InvalidCharacter(
                detail,
                uint8(raw[detail])
            );
        }
        if (code == _MARKUP) {
            revert ProhibitedMarkup(detail);
        }
        if (code == _URL) revert ProhibitedURL();
        if (code == _NO_WORDS) {
            revert DescriptionHasNoWords();
        }
        if (code == _PROHIBITED) {
            revert ProhibitedLanguage();
        }

        return keccak256(raw);
    }

    /// @notice Non-reverting policy preview for wallets and frontends.
    function isDescriptionAllowed(
        string calldata description
    ) external pure returns (bool) {
        (uint8 code, ) = _scan(bytes(description));
        return code == _VALID;
    }

    function _scan(
        bytes memory raw
    ) private pure returns (uint8 code, uint256 detail) {
        uint256 rawLength = raw.length;
        if (rawLength < MIN_DESCRIPTION_BYTES) {
            return (_EMPTY, 0);
        }
        if (rawLength > MAX_DESCRIPTION_BYTES) {
            return (_TOO_LONG, rawLength);
        }
        if (_containsURLMarker(raw)) {
            return (_URL, 0);
        }

        bytes memory normalized = new bytes(rawLength);
        uint256 writeIndex;
        bool atBoundary = true;

        for (uint256 i = 0; i < rawLength; ++i) {
            uint8 character = uint8(raw[i]);

            if (
                character > 0x7e
                    || (
                        character < 0x20
                            && character != 0x0a
                            && character != 0x0d
                    )
            ) {
                return (_INVALID_CHARACTER, i);
            }

            if (character == 0x3c || character == 0x3e) {
                return (_MARKUP, i);
            }

            (bool alphanumeric, uint8 canonical) =
                _canonicalAlphanumeric(character);

            if (alphanumeric) {
                normalized[writeIndex] = bytes1(canonical);
                ++writeIndex;
                atBoundary = false;
                continue;
            }

            if (
                character == 0x20
                    || character == 0x0a
                    || character == 0x0d
            ) {
                if (!atBoundary && writeIndex != 0) {
                    normalized[writeIndex] = 0x20;
                    ++writeIndex;
                    atBoundary = true;
                }
                continue;
            }

            if (_isJoiner(character)) {
                continue;
            }

            if (!atBoundary && writeIndex != 0) {
                normalized[writeIndex] = 0x20;
                ++writeIndex;
                atBoundary = true;
            }
        }

        if (
            writeIndex != 0
                && normalized[writeIndex - 1] == 0x20
        ) {
            --writeIndex;
        }

        if (writeIndex == 0) {
            return (_NO_WORDS, 0);
        }

        if (_containsProhibitedLanguage(normalized, writeIndex)) {
            return (_PROHIBITED, 0);
        }

        return (_VALID, 0);
    }

    function _containsProhibitedLanguage(
        bytes memory normalized,
        uint256 normalizedLength
    ) private pure returns (bool) {
        ScanContext memory scan;
        scan.normalized = normalized;
        scan.tokenTable = _BLOCKED_TOKEN_HASHES;
        scan.phraseTable = _BLOCKED_PHRASE_HASHES;
        scan.singletonSequence = new bytes(normalizedLength);
        scan.normalizedLength = normalizedLength;
        scan.previousStart = _NO_INDEX;
        scan.twoBackStart = _NO_INDEX;

        for (uint256 i = 0; i <= normalizedLength; ++i) {
            if (
                i != normalizedLength
                    && normalized[i] != 0x20
            ) {
                continue;
            }

            uint256 tokenLength = i - scan.tokenStart;
            if (tokenLength != 0) {
                if (
                    _currentWindowBlocked(
                        scan,
                        i,
                        tokenLength
                    )
                ) {
                    return true;
                }

                if (
                    _updateSingletonSequence(
                        scan,
                        tokenLength
                    )
                ) {
                    return true;
                }

                scan.twoBackStart = scan.previousStart;
                scan.twoBackEnd = scan.previousEnd;
                scan.previousStart = scan.tokenStart;
                scan.previousEnd = i;
            }

            scan.tokenStart = i + 1;
        }

        return _singletonSequenceBlocked(scan);
    }

    function _currentWindowBlocked(
        ScanContext memory scan,
        uint256 currentEnd,
        uint256 tokenLength
    ) private pure returns (bool) {
        if (
            _containsHash(
                scan.tokenTable,
                _hashSlice(
                    scan.normalized,
                    scan.tokenStart,
                    tokenLength
                )
            )
        ) {
            return true;
        }

        if (
            scan.previousStart != _NO_INDEX
                && _previousWindowBlocked(
                    scan,
                    currentEnd
                )
        ) {
            return true;
        }

        return
            scan.twoBackStart != _NO_INDEX
                && _twoBackWindowBlocked(
                    scan,
                    currentEnd
                );
    }

    function _previousWindowBlocked(
        ScanContext memory scan,
        uint256 currentEnd
    ) private pure returns (bool) {
        if (
            _containsHash(
                scan.phraseTable,
                _hashSlice(
                    scan.normalized,
                    scan.previousStart,
                    currentEnd - scan.previousStart
                )
            )
        ) {
            return true;
        }

        return
            _containsHash(
                scan.tokenTable,
                _hashJoinedTwo(
                    scan.normalized,
                    scan.previousStart,
                    scan.previousEnd,
                    scan.tokenStart,
                    currentEnd
                )
            );
    }

    function _twoBackWindowBlocked(
        ScanContext memory scan,
        uint256 currentEnd
    ) private pure returns (bool) {
        if (
            _containsHash(
                scan.phraseTable,
                _hashSlice(
                    scan.normalized,
                    scan.twoBackStart,
                    currentEnd - scan.twoBackStart
                )
            )
        ) {
            return true;
        }

        return
            _containsHash(
                scan.tokenTable,
                _hashJoinedThree(
                    scan.normalized,
                    scan.twoBackStart,
                    scan.twoBackEnd,
                    scan.previousStart,
                    scan.previousEnd,
                    scan.tokenStart,
                    currentEnd
                )
            );
    }

    function _updateSingletonSequence(
        ScanContext memory scan,
        uint256 tokenLength
    ) private pure returns (bool) {
        if (tokenLength == 1) {
            scan.singletonSequence[scan.singletonLength] =
                scan.normalized[scan.tokenStart];
            ++scan.singletonLength;
            return false;
        }

        if (
            scan.singletonLength >= 2
                && _containsHash(
                    scan.tokenTable,
                    _hashSlice(
                        scan.singletonSequence,
                        0,
                        scan.singletonLength
                    )
                )
        ) {
            return true;
        }

        scan.singletonLength = 0;
        return false;
    }

    function _singletonSequenceBlocked(
        ScanContext memory scan
    ) private pure returns (bool) {
        return
            scan.singletonLength >= 2
                && _containsHash(
                    scan.tokenTable,
                    _hashSlice(
                        scan.singletonSequence,
                        0,
                        scan.singletonLength
                    )
                );
    }

    function _canonicalAlphanumeric(
        uint8 character
    ) private pure returns (bool alphanumeric, uint8 canonical) {
        if (character >= 0x41 && character <= 0x5a) {
            return (true, character + 0x20);
        }
        if (character >= 0x61 && character <= 0x7a) {
            return (true, character);
        }
        if (character >= 0x30 && character <= 0x39) {
            if (character == 0x30) return (true, 0x6f);
            if (character == 0x31) return (true, 0x69);
            if (character == 0x33) return (true, 0x65);
            if (character == 0x34) return (true, 0x61);
            if (character == 0x35) return (true, 0x73);
            if (character == 0x37) return (true, 0x74);
            if (character == 0x38) return (true, 0x62);
            if (character == 0x39) return (true, 0x67);
            return (true, character);
        }

        return (false, 0);
    }

    function _isJoiner(
        uint8 character
    ) private pure returns (bool) {
        return
            character == 0x2e // .
                || character == 0x2d // -
                || character == 0x5f // _
                || character == 0x2a // *
                || character == 0x7e // ~
                || character == 0x2b // +
                || character == 0x2f // /
                || character == 0x5c // backslash
                || character == 0x7c // |
                || character == 0x40 // @
                || character == 0x23 // #
                || character == 0x24 // $
                || character == 0x25 // %
                || character == 0x5e // ^
                || character == 0x26 // &
                || character == 0x3d // =
                || character == 0x27 // apostrophe
                || character == 0x22 // quote
                || character == 0x60; // backtick
    }

    function _containsURLMarker(
        bytes memory raw
    ) private pure returns (bool) {
        uint256 length = raw.length;

        for (uint256 i = 0; i < length; ++i) {
            if (
                i + 2 < length
                    && raw[i] == 0x3a
                    && raw[i + 1] == 0x2f
                    && raw[i + 2] == 0x2f
            ) {
                return true;
            }

            if (
                i + 3 < length
                    && _lower(uint8(raw[i])) == 0x77
                    && _lower(uint8(raw[i + 1])) == 0x77
                    && _lower(uint8(raw[i + 2])) == 0x77
                    && raw[i + 3] == 0x2e
            ) {
                return true;
            }
        }

        return false;
    }

    function _lower(
        uint8 character
    ) private pure returns (uint8) {
        if (character >= 0x41 && character <= 0x5a) {
            return character + 0x20;
        }
        return character;
    }

    function _hashJoinedTwo(
        bytes memory data,
        uint256 firstStart,
        uint256 firstEnd,
        uint256 secondStart,
        uint256 secondEnd
    ) private pure returns (bytes32) {
        uint256 firstLength = firstEnd - firstStart;
        uint256 secondLength = secondEnd - secondStart;
        bytes memory joined =
            new bytes(firstLength + secondLength);

        _copySlice(
            data,
            firstStart,
            firstLength,
            joined,
            0
        );
        _copySlice(
            data,
            secondStart,
            secondLength,
            joined,
            firstLength
        );

        return keccak256(joined);
    }

    function _hashJoinedThree(
        bytes memory data,
        uint256 firstStart,
        uint256 firstEnd,
        uint256 secondStart,
        uint256 secondEnd,
        uint256 thirdStart,
        uint256 thirdEnd
    ) private pure returns (bytes32) {
        uint256 firstLength = firstEnd - firstStart;
        uint256 secondLength = secondEnd - secondStart;
        uint256 thirdLength = thirdEnd - thirdStart;
        bytes memory joined =
            new bytes(
                firstLength + secondLength + thirdLength
            );

        _copySlice(
            data,
            firstStart,
            firstLength,
            joined,
            0
        );
        _copySlice(
            data,
            secondStart,
            secondLength,
            joined,
            firstLength
        );
        _copySlice(
            data,
            thirdStart,
            thirdLength,
            joined,
            firstLength + secondLength
        );

        return keccak256(joined);
    }

    function _copySlice(
        bytes memory source,
        uint256 sourceStart,
        uint256 length,
        bytes memory destination,
        uint256 destinationStart
    ) private pure {
        for (uint256 i = 0; i < length; ++i) {
            destination[destinationStart + i] =
                source[sourceStart + i];
        }
    }

    function _hashSlice(
        bytes memory data,
        uint256 start,
        uint256 length
    ) private pure returns (bytes32 result) {
        assembly ("memory-safe") {
            result := keccak256(
                add(add(data, 0x20), start),
                length
            )
        }
    }

    function _containsHash(
        bytes memory table,
        bytes32 target
    ) private pure returns (bool) {
        uint256 low;
        uint256 high = table.length / 32;

        while (low < high) {
            uint256 middle = (low + high) >> 1;
            bytes32 candidate;

            assembly ("memory-safe") {
                candidate := mload(
                    add(
                        add(table, 0x20),
                        mul(middle, 0x20)
                    )
                )
            }

            if (uint256(candidate) < uint256(target)) {
                low = middle + 1;
            } else {
                high = middle;
            }
        }

        if (low >= table.length / 32) return false;

        bytes32 found;
        assembly ("memory-safe") {
            found := mload(
                add(
                    add(table, 0x20),
                    mul(low, 0x20)
                )
            )
        }

        return found == target;
    }
}
