import React from 'react';
import '../stylesheets/NavBar.css';

type NavState = {
}

type NavProps = {
}

class Nav extends React.Component<NavProps,NavState>{
    render() {
        return(
            <div className="NavBar">
                <h1 className="NavBarTitle">
                    Split-It
                </h1>
            </div>
        )
    }
}

export default Nav;
