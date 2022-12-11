import * as React from 'react';
import { Github ,Category } from 'sketch-icons';
import Logo from "./assets/logo.png";
import {
    Flex,
    Heading,
    Box,
    Spacer,
    Button,
    Image,
    Code,
    Stack,
    LinkOverlay,
    Link,
    Menu,
    IconButton,
    MenuList,
    MenuItem,
    MenuButton,
    useColorModeValue,
} from '@chakra-ui/react'; 
import { ColorModeSwitcher } from '../ColorModeSwitcher';
import { useMediaQuery } from '@chakra-ui/react';
export const Nav = () => {
    const iconColor = useColorModeValue('#2A2238', 'white');

    const [isTablet] = useMediaQuery('(max-width: 768px)');

    const menuStyle = {
        fontFamily: 'system-ui',
        color: 'gray.100',
        fontSize: '16px',
    };

    return (
        <Flex as="header" p="5">
            <Box p={2} ml={isTablet ? '2' : '5'}>
                <Stack direction="row" isInline>
                    <Image boxSize={{ base: '40px', md: '45px' }} 
                    objectFit="cover" 
                    src = {Logo}
                   alt="Beyolix" />
                    <Link href="/" style={{ textDecoration: 'none' }}>
                        <Heading fontSize={{ base: '20px', md: '25px', lg: '30px' }} fontFamily="system-ui">
                        Beyolix &nbsp;
                            <span>
                                <Code>v1.0.0</Code>
                            </span>
                        </Heading>
                    </Link>
                </Stack>
            </Box>
            <Spacer />
            {isTablet ? (
                <Menu>
                    <MenuButton
                        mr="3"
                        as={IconButton}
                        bg="gray.100"
                        aria-label="Options"
                        icon={<Category width={20} height={20} />}
                        variant="outline"
                    />
                    <MenuList>
                         
                        <MenuItem
                            as={Link}
                            isExternal
                            href="https://github.com/ndrohith09/Beyolix"
                            style={menuStyle}
                            icon={<Github color={iconColor} height="12" width="12" />}
                        >
                            Github
                        </MenuItem> 
                        
                    </MenuList>
                </Menu>
            ) : (
                <Box> 
                    <Button color="current" leftIcon={<Github color={iconColor} height="14" width="14" />} mr="5">
                        <LinkOverlay isExternal href="https://github.com/ndrohith09/Beyolix">
                            Github
                        </LinkOverlay>
                    </Button> 
                </Box>
            )}
            <ColorModeSwitcher mr="5" justifySelf="flex-end" />
        </Flex>
    );
};